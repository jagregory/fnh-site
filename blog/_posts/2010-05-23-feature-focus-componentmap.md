---
layout: blog
title: ComponentMap (1.1 Feature Focus)
author: James Gregory
---
In the 1.1 release we've introduced a new mapping class to help clean up your mappings: the ComponentMap. The ComponentMap is extremely similar to ClassMap and ComponentMap, with the exception that it's for mapping components.

When you have components that are cropping up in various places across your domain (Address, ContactDetails, Location, etc...), it can be a nuisance  to keep repeating the mappings for them. Some people have come up with some clever work arounds for this issue, but hopefully those won't be necessary now.

Given a common component, we'd map it with the ComponentMap like so:

    public class AddressMap : ComponentMap<Address>
    {
      public AddressMap()
      {
        Map(x => x.Street);
        Map(x => x.City);
        Map(x => x.State);
        Map(x => x.PostalCode);
      }
    }

Then in your ClassMaps or SubclassMaps you just use the bodyless <code>Component</code> method, which indicates to Fluent NHibernate that it should resolve the actual mapping for the component externally.

    Component(x => x.Address);

Any place in your domain where you use the above address will receive a copy of the mapping as defined in <code>AddressMap</code>.

If you require a prefix for your component columns, you can use the <code>ColumnPrefix</code> method from the <code>Component</code> method.

    Component(x => x.WorkAddress)
      .ColumnPrefix("{property}_");

> Note: as with <code>SubclassMap</code>, <code>ComponentMap</code> isn't (as yet) compatible with the automapper. If you're using the automapper then you're better off using the <code>IsComponent</code> configuration option.
