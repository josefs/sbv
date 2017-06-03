---------------------------------------------------------------------------------
-- |
-- Module      :  Data.SBV.Internals
-- Copyright   :  (c) Levent Erkok
-- License     :  BSD3
-- Maintainer  :  erkokl@gmail.com
-- Stability   :  experimental
--
-- Low level functions to access the SBV infrastructure, for developers who
-- want to build further tools on top of SBV. End-users of the library
-- should not need to use this module.
---------------------------------------------------------------------------------

module Data.SBV.Internals (
  -- * Running symbolic programs /manually/
    Result(..), SBVRunMode(..)

  -- * Solver capabilities
  , SolverCapabilities(..)

  -- * Internal structures useful for low-level programming
  , module Data.SBV.Core.Data

  -- * Operations useful for instantiating SBV type classes
  , genLiteral, genFromCW, CW(..), genMkSymVar, checkAndConvert, genParse, showModel, SMTModel(..), liftQRem, liftDMod

  -- * Getting SMT-Lib output (for offline analysis)
  , compileToSMTLib, generateSMTBenchmarks

  -- * Compilation to C, extras
  , compileToC', compileToCLib'

  -- * Code generation primitives
  , module Data.SBV.Compilers.CodeGen

  -- * Various math utilities around floats
  , module Data.SBV.Utils.Numeric

  -- * Pretty number printing
  , module Data.SBV.Utils.PrettyNum

  -- * Timing computations
  , module Data.SBV.Utils.TDiff

  -- * Sending an arbitrary string
  -- $sendStringInfo
  , sendStringToSolver, sendRequestToSolver

  ) where

import Data.SBV.Core.Data
import Data.SBV.Core.Model      (genLiteral, genFromCW, genMkSymVar)
import Data.SBV.Core.Splittable (checkAndConvert)
import Data.SBV.Core.Model      (liftQRem, liftDMod)

import Data.SBV.Compilers.C       (compileToC', compileToCLib')
import Data.SBV.Compilers.CodeGen

import Data.SBV.Provers.Prover (compileToSMTLib, generateSMTBenchmarks)

import Data.SBV.SMT.SMT (genParse, showModel)

import Data.SBV.Utils.Numeric

import Data.SBV.Utils.TDiff
import Data.SBV.Utils.PrettyNum

import qualified Data.SBV.Control.Utils as CUtils

-- | Send an arbitrary string to the solver in a query.
-- Note that this is inherently dangerous as it can put the solver in an arbitrary
-- state and confuse SBV.
sendStringToSolver :: String -> Query ()
sendStringToSolver = CUtils.send

-- | Send an arbitrary string to the solver in a query, and return a response.
-- Note that this is inherently dangerous as it can put the solver in an arbitrary
-- state and confuse SBV.
sendRequestToSolver :: String -> Query String
sendRequestToSolver = CUtils.ask

{- $sendStringInfo
In rare cases it might be necessary to send an arbitrary string down to the solver. Needless to say, this
should be avoided if at all possible. Users should prefer the provided API. If you do find yourself
needing 'send' and 'ask' directly, please get in touch to see if SBV can support a typed API for your use case.
-}

{-# ANN module ("HLint: ignore Use import/export shortcut" :: String) #-}
