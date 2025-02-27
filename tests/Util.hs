-- -*- Mode: Haskell; -*-
--
-- HTagLib tests, utility definitions.
--
-- Copyright © 2015 Mark Karpov
--
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are
-- met:
--
-- * Redistributions of source code must retain the above copyright notice,
--   this list of conditions and the following disclaimer.
--
-- * Redistributions in binary form must reproduce the above copyright
--   notice, this list of conditions and the following disclaimer in the
--   documentation and/or other materials provided with the distribution.
--
-- * Neither the name Mark Karpov nor the names of contributors may be used
--   to endorse or promote products derived from this software without
--   specific prior written permission.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS “AS IS” AND ANY
-- EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
-- WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
-- DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS BE LIABLE FOR ANY
-- DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
-- DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
-- OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
-- HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
-- STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
-- ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-- POSSIBILITY OF SUCH DAMAGE.

{-# LANGUAGE OverloadedStrings #-}

module Util
  ( AudioTags (..)
  , sampleGetter
  , sampleTags
  , fileList
  , caseWithFile )
where

import Data.Maybe (fromJust)
import Sound.HTagLib

import Test.Framework
import Test.Framework.Providers.HUnit (testCase)
import Test.HUnit hiding (Test, path)

#if !MIN_VERSION_base(4,8,0)
import Control.Applicative ((<$>), (<*>), pure)
#endif

data AudioTags = AudioTags
  { atFileName    :: FilePath
  , atTitle       :: Title
  , atArtist      :: Artist
  , atAlbum       :: Album
  , atComment     :: Comment
  , atGenre       :: Genre
  , atYear        :: Maybe Year
  , atTrackNumber :: Maybe TrackNumber
  , atDuration    :: Duration
  , atBitRate     :: BitRate
  , atSampleRate  :: SampleRate
  , atChannels    :: Channels }
  deriving (Show, Eq)

sampleGetter :: FilePath -> TagGetter AudioTags
sampleGetter path = AudioTags
  <$> pure path
  <*> titleGetter
  <*> artistGetter
  <*> albumGetter
  <*> commentGetter
  <*> genreGetter
  <*> yearGetter
  <*> trackNumberGetter
  <*> durationGetter
  <*> bitRateGetter
  <*> sampleRateGetter
  <*> channelsGetter

sampleTags :: FilePath -> AudioTags
sampleTags path = AudioTags
  { atFileName    = path
  , atTitle       = "title"
  , atArtist      = "artist"
  , atAlbum       = "album"
  , atComment     = "comment"
  , atGenre       = "genre"
  , atYear        = mkYear 2055
  , atTrackNumber = mkTrackNumber 7
  , atDuration    = fromJust $ mkDuration 0
  , atBitRate     = fromJust $ mkBitRate 0
  , atSampleRate  = fromJust $ mkSampleRate 44100
  , atChannels    = fromJust $ mkChannels 2 }

fileList :: [(String, FileType)]
fileList =
  [ ("audio-samples/sample.flac", FLAC)
  , ("audio-samples/sample.mp3",  MPEG) ]

caseWithFile :: Show a => (a -> Assertion) -> a -> Test
caseWithFile f param = testCase ("checking file: " ++ show param) (f param)
