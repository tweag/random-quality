{-# LANGUAGE BangPatterns #-}

module Main where

import Control.Monad (forever)
import Data.IORef (newIORef, readIORef, writeIORef)
import Data.Word (Word32)
import System.Environment (getArgs)

import qualified Data.ByteString.Builder as BS
import qualified Data.ByteString.Builder.Prim as BS
import qualified System.IO as IO
import qualified System.Random as R
import qualified System.Random.SplitMix as SM

-------------------------------------------------------------------------------
-- Helpers with explicit types
-------------------------------------------------------------------------------

randomInt :: R.RandomGen g => g -> (Int, g)
randomInt = R.random

random32 :: R.RandomGen g => g -> (Word32, g)
random32 = R.random

-------------------------------------------------------------------------------
-- Sequence of random numbers, no splitting
-------------------------------------------------------------------------------

defaultSequence ::
     (R.RandomGen g, Integral i, Integral j) => BS.FixedPrim i -> (g -> (j, g)) -> g -> (BS.Builder, g)
defaultSequence prim f gen =
  let (r1, gen1) = f gen
      (r2, gen2) = f gen1
      (r3, gen3) = f gen2
      (r4, gen4) = f gen3
   in ( BS.primFixed
          (prim BS.>*< prim BS.>*< prim BS.>*< prim)
          (fromIntegral r1, (fromIntegral r2, (fromIntegral r3, fromIntegral r4)))
      , gen4)

defaultSequenceInt ::
     R.RandomGen g => (g -> (Int, g)) -> g -> (BS.Builder, g)
defaultSequenceInt = defaultSequence BS.word32Host

defaultSequenceWord32 ::
     R.RandomGen g => (g -> (Word32, g)) -> g -> (BS.Builder, g)
defaultSequenceWord32 = defaultSequence BS.word32Host

-------------------------------------------------------------------------------
-- Sequences of random numbers that use 'split'
--
-- The functions in this section implement sequences defined in sections 5.5
-- and 5.6 of the following paper:
--
-- Hans Georg Schaathun. 2015. Evaluation of splittable pseudo-random
-- generators. Journal of Functional Programming, Vol. 25.
-- https://doi.org/10.1017/S095679681500012X
-------------------------------------------------------------------------------

-- | Generate a sequence ("sequence S") for stress-testing splittable RNGs.
--
-- Implements sequence S in Schaathun 2015, section 5.5.
splitSequence ::
     (R.RandomGen g, Integral i, Integral j) => BS.FixedPrim i -> (g -> (j, g)) -> g -> (BS.Builder, g)
splitSequence prim f gPrev =
  let (gNext, g) = R.split gPrev
      (gL, gR) = R.split g
      (gLL, gLR) = R.split gL
      (gRL, gRR) = R.split gR
      rLL = fst $ f gLL
      rLR = fst $ f gLR
      rRL = fst $ f gRL
      rRR = fst $ f gRR
   in ( BS.primFixed
          (prim BS.>*< prim BS.>*< prim BS.>*< prim)
          (fromIntegral rLL, (fromIntegral rLR, (fromIntegral rRL, fromIntegral rRR)))
      , gNext)

-- | Generate a sequence ("sequence S_A") for stress-testing splittable RNGs.
--
-- Implements sequence S_A in Schaathun 2015, section 5.6.
splitSequenceA ::
     (R.RandomGen g, Integral i, Integral j) => BS.FixedPrim i -> (g -> (j, g)) -> g -> (BS.Builder, g)
splitSequenceA prim f gPrev =
  let (gL, gR) = R.split gPrev
      (vR, _) = f gR
      (gLL, gLR) = R.split gL
      (vLL, _) = f gLL
   in (BS.primFixed (prim BS.>*< prim) (fromIntegral vR, fromIntegral vLL), gLR)

-- | Generate a sequence ("sequence S_L") for stress-testing splittable RNGs.
--
-- Implements sequence S_L in Schaathun 2015, section 5.6.
splitSequenceL ::
     (R.RandomGen g, Integral i, Integral j) => BS.FixedPrim i -> (g -> (j, g)) -> g -> (BS.Builder, g)
splitSequenceL prim f gPrev =
  let (gL, gR) = R.split gPrev
      (vL, _) = f gL
   in (BS.primFixed BS.word32Host (fromIntegral vL), gR)

-- | Generate a sequence ("sequence S_R") for stress-testing splittable RNGs.
--
-- Implements sequence S_R in Schaathun 2015, section 5.6.
splitSequenceR ::
     (R.RandomGen g, Integral i, Integral j) => BS.FixedPrim i -> (g -> (j, g)) -> g -> (BS.Builder, g)
splitSequenceR prim f gPrev =
  let (gL, gR) = R.split gPrev
      (vR, _) = f gR
   in (BS.primFixed prim (fromIntegral vR), gL)

-------------------------------------------------------------------------------
-- Output
-------------------------------------------------------------------------------

spew :: R.RandomGen g => IO.Handle -> g -> (g -> (BS.Builder, g)) -> IO ()
spew h initialGen f = do
  ref <- newIORef initialGen
  forever $ do
    gen <- readIORef ref
    let (v, gen') = f gen
    BS.hPutBuilder h v
    writeIORef ref gen'

-------------------------------------------------------------------------------
-- Main
-------------------------------------------------------------------------------

main :: IO ()
main = do
  let !stdout = IO.stdout
  args <- getArgs
  case args of
    -- random
    ["random-int"] ->
      spew stdout (R.mkStdGen 1337) (defaultSequenceInt randomInt)
    ["random-word32"] ->
      spew stdout (R.mkStdGen 1337) (defaultSequenceWord32 random32)
    ["random-word32-split"] ->
      spew stdout (R.mkStdGen 1337) (splitSequence BS.word32Host random32)
    ["random-word32-splita"] ->
      spew stdout (R.mkStdGen 1337) (splitSequenceA BS.word32Host random32)
    ["random-word32-splitl"] ->
      spew stdout (R.mkStdGen 1337) (splitSequenceL BS.word32Host random32)
    ["random-word32-splitr"] ->
      spew stdout (R.mkStdGen 1337) (splitSequenceR BS.word32Host random32)

    -- splitmix
    ["splitmix-word32"] ->
      spew stdout (SM.mkSMGen 1337) (defaultSequenceWord32 SM.nextWord32)
    ["splitmix-word32-split"] ->
      spew stdout (SM.mkSMGen 1337) (splitSequence BS.word32Host SM.nextWord32)
    ["splitmix-word32-splita"] ->
      spew stdout (SM.mkSMGen 1337) (splitSequenceA BS.word32Host SM.nextWord32)
    ["splitmix-word32-splitl"] ->
      spew stdout (SM.mkSMGen 1337) (splitSequenceL BS.word32Host SM.nextWord32)
    ["splitmix-word32-splitr"] ->
      spew stdout (SM.mkSMGen 1337) (splitSequenceR BS.word32Host SM.nextWord32)
