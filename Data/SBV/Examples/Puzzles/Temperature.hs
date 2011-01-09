{- (c) Copyright Levent Erkok. All rights reserved.
--
-- The sbv library is distributed with the BSD3 license. See the LICENSE file
-- in the distribution for details.
-}

module Data.SBV.Examples.Puzzles.Temperature where

import Data.SBV
import Data.SBV.Utils.SBVTest

type Temp = SWord16 -- larger than we need actually

-- convert celcius to fahrenheit, rounding up/down properly
-- we have to be careful here to make sure rounding is done properly..
d2f :: Temp -> Temp
d2f d = 32 + ite (fr .>= 5) (1+fi) fi
  where (fi, fr) = (18 * d) `bvQuotRem` 10

-- puzzle: What 2 digit fahrenheit/celcius values are reverses of each other?
revOf :: Temp -> SBool
revOf c = swap (digits c) .== digits (d2f c)
  where digits x = x `bvQuotRem` 10
        swap (a, b) = (b, a)

solve :: IO ()
solve = do res <- allSat $ free_ >>= output . revOf
           cnt <- displayModels disp res
           putStrLn $ "Found " ++ show cnt ++ " solutions."
     where disp :: Int -> Word16 -> IO ()
           disp _ x = putStrLn $ " " ++ show x ++ "C --> " ++ show ((round f) :: Integer) ++ "F (exact value: " ++ show f ++ "F)"
              where f :: Double
                    f  = 32 + (9 * fromIntegral x) / 5

-- Test suite
testSuite :: SBVTestSuite
testSuite = mkTestSuite $ \goldCheck -> test [
  "temperature" ~: sat revOf `goldCheck` "temperature.gold"
 ]
