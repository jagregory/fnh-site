---
layout: default
title: Blog
---
## Blog posts...
{% for post in site.posts %}
 [{{ post.title }}]({{ post.url }})
{% endfor %}
