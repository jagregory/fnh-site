---
layout: default
title: Downloads
---

<p class="mainDownload"><a title="Download the latest Fluent NHibernate release (version 1.1)" href="/downloads/releases/fluentnhibernate-1.1.zip" onclick="javascript:pageTracker._trackEvent('Downloads', 'Release', '/downloads/releases/1.1');"><span>Download</span> Fluent NHibernate 1.1</a></p>

<p class="subtext"><a href="javascript:void(0);" id="previousReleasesToggle">Show previous releases</a></p>

<div id="previousReleases" class="alt">
	<h3>Previous releases</h3>
	<ul>
	  <li><a href="/downloads/releases/fluentnhibernate-1.0RTM.zip" onclick="javascript:pageTracker._trackEvent('Downloads', 'Release', '/downloads/releases/1.0RTM');">Fluent NHibernate 1.0RTM</a></li>
	  <li><a href="/downloads/releases/fluentnhibernate-1.0RC.zip" onclick="javascript:pageTracker._trackEvent('Downloads', 'Release', '/downloads/releases/1.0RC');">Fluent NHibernate 1.0RC</a></li>
	</ul>
</div>

## Nuget package

You can download Fluent NHibernate and use it in your project easily thanks to [Nuget](http://nuget.org). To install Fluent NHibernate, execute the following command from your package management console:

    PM> Install-Package FluentNHibernate

Alternatively, you can view the [Fluent NHibernate package](http://nuget.org/List/Packages/FluentNHibernate) in the Nuget Gallery.

## Continuous integration server builds
    
Our continuous integration server churns out a binary and source release every time anyone commits. You can use these builds instead of the official release if there's something specific you need (but we'd rather you stick to the releases if possible).

To download the latest build, goto our [TeamCity builds page](http://teamcity.codebetter.com/project.html?projectId=project8&tab=projectOverview&guest=1) and view the Artifacts for the configuration you need. The `master` build should be considered *extremely unstable*, you have been warned.
    
## Source code

If you would like to build Fluent NHibernate yourself or help us out with contributions, you can get the source code from our Github repository.
  
<div class="alt">
  <p>Github: <code><a href="http://github.com/jagregory/fluent-nhibernate">http://github.com/jagregory/fluent-nhibernate</a></code></p>
  <p>Clone url: <code>git://github.com/jagregory/fluent-nhibernate.git</code></p>
</div>

If you are interested in contributing, have a read of the [contributing guide](http://wiki.fluentnhibernate.org/Contributing) on our [wiki](http://wiki.fluentnhibernate.org), and drop by the [mailing list](http://groups.google.com/group/fluent-nhibernate).