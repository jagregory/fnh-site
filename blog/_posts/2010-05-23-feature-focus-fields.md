---
layout: blog
title: Field support (1.1 Feature Focus)
author: James Gregory
---
Fluent NHibernate has always had an hard-coded restriction on what members you can use for mapping. In some cases this restriction is fairly sensible (static reflection doesn't support exposing private fields), but in other cases it doesn't make much sense (automapping).

With the advent of 1.1, we now have full private member support.


## ClassMaps

The mapping interface is still limited by the capabilities of expression building, so you still can't use the traditional <code>Map(x => x.field)</code> syntax to expose fields (private ones, anyway); however, the <code>Reveal</code> functionality is now capable of exposing fields as well as private properties.

    Reveal.Member<YourEntity>("_privateField");

    Map(Reveal.Member<YourEntity>("_privateField"));

Any method that accepts an <code>Expression</code> can now be used with the above syntax. It's not compile-safe, but some sacrifices have to be made.


## Automapping

The area where these changes really shine is automapping. The automapper is now fully capable of dealing with fields as a legitimate way to persist your entities.

Using the automapping configuration style (highlighted in the [automapping configuration feature focus](/blog/2010/05/23/feature-focus-automapping.html)) we'll instruct the automapper to use fields instead of properties.

    public class AppAutomappingCfg : DefaultAutomappingConfiguration
    {
      public override bool ShouldMap(Member member)
      {
        return member.IsPrivate && member.IsField;
      }
    }

That's it, your automapper will now only map private fields. You're obviously fully capable of making your own rules up for what fields should be mapped. You could use a combination of fields and properties, only private fields, fields with certain attributes, etc... It's up to you.
