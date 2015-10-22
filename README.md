This is still a work in progress.

Currently the following policies are provided:

* ProhibitMergedParameters: detects `params`.
* ProhibitObsoleteImport: detects old import options.
* ProhibitObsoleteKeywords: detects keywords that are no longer supported.
* RequireLeadingForwardSlash: detects leading slash in path. To be removed.

The `eg` directory contains examples of what we detect and complain about.

The `RequireLeadingForwardSlash` will be removed since it's not wrong and
can actually be used in a smart way.
