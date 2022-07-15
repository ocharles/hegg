{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE Rank2Types #-}
module Data.Equality.Graph.Lens where

import Data.Functor.Identity
import Data.Functor.Const

import Data.Equality.Graph.Classes.Id
import Data.Equality.Graph.Nodes
import Data.Equality.Graph.Classes
import Data.Equality.Analysis
import {-# SOURCE #-} Data.Equality.Graph (EGraph, getClass, setClass)

type Lens' s a = forall f. Functor f => (a -> f a) -> (s -> f s)


_class :: ClassId -> Lens' (EGraph l) (EClass l)
_class i afa s =
    let (i', c) = getClass i s
     in setClass s i' <$> afa c

_data :: Lens' (EClass l) (Domain l)
_data afa EClass{..} = (\d1 -> EClass eClassId eClassNodes d1 eClassParents) <$> afa eClassData

_parents :: Lens' (EClass l) [(ENode l, ClassId)]
_parents afa EClass{..} = EClass eClassId eClassNodes eClassData <$> afa eClassParents

-- | Like @'view'@ but with the arguments flipped
(^.) :: s -> Lens' s a -> a
(^.) s ln = view ln s
infixl 8 ^.
{-# INLINE (^.) #-}

-- | Synonym for @'set'@
(.~) :: Lens' s a -> a -> (s -> s)
(.~) = set
infixr 4 .~
{-# INLINE (.~) #-}

-- | Synonym for @'over'@
(%~) :: Lens' s a -> (a -> a) -> (s -> s)
(%~) = over
infixr 4 %~
{-# INLINE (%~) #-}

view :: Lens' s a -> (s -> a)
view ln = getConst . ln Const
{-# INLINE view #-}

set :: Lens' s a -> a -> (s -> s)
set ln x = over ln (const x)
{-# INLINE set #-}

over :: Lens' s a -> (a -> a) -> (s -> s)
over ln f = runIdentity . ln (Identity . f)
{-# INLINE over #-}
