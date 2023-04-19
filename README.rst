sitecopy
========

This is a Dockerized version of `sitecopy`_, a website synchronization
tool.  Invoke it like this for a help message::

  docker run --rm -it gbenson/sitecopy --help

To do actual work you'll need to mount a filesystem into the container
so sitecopy can access the outside world.  The container's default
working directory is the empty directory ``/work``, and I usually run
sitecopy with my out-of-container working directory mounted there::

  docker run --rm -it --mount type=bind,src=$(pwd),target=/work gbenson/sitecopy -u gbenson.net

Doing things that way keeps relative paths the same and is about as
seamless as it gets.

.. Links
.. _sitecopy: https://www.manyfish.co.uk/sitecopy/
