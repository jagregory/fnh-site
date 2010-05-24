---
layout: blog
title: Automapping Configuration (1.1 Feature Focus)
author: James Gregory
---
Automapping is conventional. It's great when those conventions match up with your own, but how often is that in reality? Nearly everybody needs to configure the automapper to some degree. Some more than others.

Does your automapping configuration look anything like this:

    AutoMap.AssemblyOf<Person>()
      .Where(x => x.Namespace.EndsWith("Domain"))
      .IgnoreBase<EntityBase>()
      .Setup(cfg =>
      {
        cfg.FindIdentity = member => member.Name == "EntityId";
        cfg.IsDiscriminated = type => type == typeof(Person);
        cfg.IsComponentType = type => type.In(typeof(Address), typeof(ContactDetails));
        cfg.AbstractClassIsLayerSupertype = type => type == typeof(Client);
      });

Ok, so that's a pretty big example. Not everyone's is going to look like that, but they do exist. It's a bit bloated? How about when you also put it in the context of your overall configuration?

    Fluently.Configure()
      .Database(SQLiteConfiguration.Standard.InMemory())
      .Mappings(m =>
      {
        m.FluentMappings.AddFromAssemblyOf<Person>();
        
        m.AutoMappings.Add(
          AutoMap.AssemblyOf<Person>()
            .Where(x => x.Namespace.EndsWith("Domain"))
            .IgnoreBase<EntityBase>()
            .Setup(cfg =>
            {
              cfg.FindIdentity = member => member.Name == "EntityId";
              cfg.IsDiscriminated = type => type == typeof(Person);
              cfg.IsComponentType = type => type.In(typeof(Address), typeof(ContactDetails));
              cfg.AbstractClassIsLayerSupertype = type => type == typeof(Client);
            });
        );
      })
      .BuildSessionFactory();

That's looking even messier now and, more importantly, a lot more difficult to mentally parse how the automapping is being configured. It's a big lump of method chaining mess.

The changes that we've made for the 1.1 release have introduced the concept of a configuration object for the automapper. Basically, it's the contents of the Setup method combined with the Where clause, extracted into a separate object. This change greatly reduces the noise in your configuration, gives you a known location for your automapping configuration (rather than having to dig around in your NHibernate session manager code), and increases your ability to replace and inject different configurations.

Lets take a look at how the above is done in 1.1. We'll start with just the automapping configuration.

The automapping configuration is based on implementing the IAutomappingConfiguration interface; this interface contains several methods that the automapper uses to know how to map your domain. Fear not though, you don't need to implement all these methods yourself (unless you want to). There's a DefaultAutomappingConfiguration class which is pre-configured with all the automapping defaults; you can derive from that class and just override whatever options you choose.

    public class AppAutomappingCfg : DefaultAutomappingConfiguration
    {
      IEnumerable<Type> ignoredTypes = new[] {
        typeof(EntityBase)
      };

      public override bool ShouldMap(Type type)
      {
        if (ignoredTypes.Contains(type))
          return false;

        return type.Namespace.EndsWith("Domain");
      }
      
      public override bool IsDiscriminated(Type type)
      {
        return type == typeof(Person);
      }
      
      public override bool IsComponent(Type type)
      {
        return type.In(typeof(Address), typeof(ContactDetails));
      }
      
      public override bool AbstractClassIsLayerSupertype(Type type)
      {
        return type == tyepof(Client);
      }
    }

That's our application's automapping configuration. It's pretty self explanatory really; the only method that might be unfamiliar is <code>ShouldMap(Type)</code>, and this is simply a replacement for the <code>Where</code> method. You can see in the <code>ShouldMap</code> method we've also got a <code>Contains</code> call on a collection, this is an example of how you could roll the <code>IgnoreBase</code> usage into your configuration; however, this is not required and you are still free to use <code>IgnoreBase</code> if you prefer.

To utilise this new configuration we need to modify our original <code>AutoMap</code> call:

    AutoMap.AssemblyOf<Person>(new AppAutomappingCfg());

That's all there is to our automapping call now, everything's incorporated in the configuration. Adding a little context, here's how it now looks in the whole configuration:

    Fluently.Configure()
      .Database(SQLiteConfiguration.Standard.InMemory())
      .Mappings(m =>
      {
        m.FluentMappings.AddFromAssemblyOf<Person>();
        
        m.AutoMappings.Add(
          AutoMap.AssemblyOf<Person>(new AppAutomappingCfg())
        );
      })
      .BuildSessionFactory();

Much tidier!
