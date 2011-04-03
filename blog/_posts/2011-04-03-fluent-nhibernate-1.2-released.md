---
layout: blog
title: Fluent NHibernate 1.2 released
author: James Gregory
---
It's been a long time coming. Fluent NHibernate 1.2 is now officially released. You can download it from the [website downloads page](http://fluentnhibernate.org/downloads).

The bulk of changes are bugfixes, but we've also upgraded to NHibernate 3.1. There's a few fancy things around [access strategies](http://wiki.fluentnhibernate.org/Fluent_mapping#Access_strategies) and [IEnumerable's](http://wiki.fluentnhibernate.org/Fluent_mapping#Collection_types), and some [diagnostics](https://github.com/jagregory/fluent-nhibernate/commit/8c7ad8d3887d7c5146a8982e06e9062986bf15e4) thrown in for good measure. For everything else, you can read the [release notes](http://wiki.fluentnhibernate.org/Release_notes_1.2).

We've also taken ownership of the [Fluent NHibernate Nuget package](http://nuget.org/List/Packages/FluentNHibernate) which has been updated for this release.

This will hopefully be the last release of our 1.x code path, which will give us plenty of time to work on some shiny features for 2.0.