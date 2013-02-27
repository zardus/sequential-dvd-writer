dvdwrite
========

This is a little UI to help in the creation of DVD archives for organized data. If, for example, you have a lot of Ubuntu ISOs and are trying to burn them off to DVDs, it'll create DVDs of alphabetically consecutive ISOs in the right directories.

I wrote this thing a VERY VERY long time ago, when I was still using Perl. Because I was lazy, it shells out for almost everything. It worked the last time I tried it, but that was probably about 5 years ago, so no guarantees.

To launch it, do:

```bash
dvdwrite.sh /media/to/burn
```

It also has a mode that'll let you copy DVDs you've made with it (or potentially, through some other method) to a directory:

```bash
dvdread.sh /path/to/directory
```

Enjoy!

License
=======

I dunno why anyone would want to base any code off of this, but just in case you do, it's licensed under the GPLv3.
