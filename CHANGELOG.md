# Revision history for hegg

## Unreleased

## 0.4.0.0 -- 2023-06-24

* Make `Language` a constraint type synonym instead of a standalone empty class
* Use `QuantifiedConstraints` instead of `Eq1,Ord1,Show1` in the implementation,
    which results in the user only having to provide an `Eq a => Eq (language
    a)` instance rather than a `Eq1 language` one (which is much simpler and can
    usually be done automatically!)
* Make `_classes` a `Traversal` lens over all e-classes rather than a `Lens` into `IntMap EClass`

## 0.3.0.0 -- 2022-12-09

* A better `Analysis` tutorial in the README.

* Complete `Analysis` redesign.
    * The `Analysis` class now has two type parameters: a `domain` and a
        `language`, and no longer has an associated type family
    * The analysis no longer has any knowledge of the e-graph:
        * `makeA` now has type `l domain -> domain`, that is, to make a domain
            of a new node we only have to take into consideration the data of
            the sub-nodes of the new node.
        * `joinA` is unchanged.
        * `modifyA` now has type `EClass domain lang -> (EClass domain lang,
            [Fix lang])`. It takes an e-class and optionally modifies it,
            possibly by adding nodes to it. The return value is the modified
            e-class, and a list of expressions from the language to add to the
            e-class.
    * We can now compose analysis and create language-polymorphic analysis. Such
        two examples are the analysis with domain `()` which regardless of the
        language simply ignores the domain: `instance Analysis () l`; and the
        second example is the product of analysis, which composes two separate
        analysis into one: `instance (Analysis a l, Analysis b l) => Analysis
        (a,b) l`.
    * An `EGraph` now also has two type parameters instead of one (the latter is
      the language is the former the domain of the analysis).

* Allow customization of Schedulers through parameters (by accepting a scheduler
    rather than a proxy for it)

## 0.2.0.0 -- 2022-09-19

* Expose `runEqualitySaturation` to run equality saturation on existing e-graphs
    whole instead of focusing on individual expressions
* (Very) significant performance improvements!
* Make `CostFunction` polymorphic over the `Cost` type, requiring that type
    to instance `Ord`
* Make e-graph abstract. The internal structure can still be modified through
    the available lenses in `Data.Equality.Graph.Lens`
* Fix a bug related to `NodeMap`'s size.

## 0.1.0.0 -- 2022-08-25

* First version. Released on an unsuspecting world.
