# Recommended Search Results plugin for Movable Type and Melody

The Recommended Search Results plugin for Movable Type and Melody aims to give
users more relevant search results. We all know the problem: you've written a
*lot* about Widgets. When a user searches they see pages and pages of all your
entries about Widgets. Where does the user start; which entry is most likely
helpful for them? The entry "Widgets Canon" is likely the result most helpful
to a user but because it's old it doesn't appear on the first page of search
results; the entries "Red Widgets" and "Blue Widgets" are not as useful, but
were recent so appear first in the results.

Enter Recommended Search Results: tag "Widgets Canon" (perhaps with a tag like
`@recommended`) and make some template modifications to highlight this entry
and make it stand out for the user. Now when they search, right at the top of
the search results they can find the "Widgets Canon" with everything they need
to know about Widgets.

# Installation

To install this plugin follow the instructions found here:

http://tinyurl.com/easy-plugin-install

# Template Tags

This plugin add a new block tag: `RecommendedSearchResults`. One argument is
required: `tag`. This argument should be the tag name you are using to
indicate which entries are recommended. A good choice is `@recommended`: the
name is clear, and it's a private tag because it's preceded by `@`, which
means the tag won't be published on pages.

This block tag also supports the meta variables `__first__`, `__last__`,
`__even__`, `__odd__`, and `__counter__`.

Example:

    <mt:RecommendedSearchResults tag="@recommended">
        <mt:If name="__first__">
        <h3>Recommended Search Results</h3>
        <ul>
        </mt:If>

            <li><a href="<mt:EntryPermalink>"><mt:EntryTitle></a></li>

        <mt:If name="__last__">
        </ul>
        </mt:If>
    </mt:RecommendedSearchResults>

This tag is, of course, only valid and useful on the Search Results template.

# Use

Just add the selected tag to any Entries or Pages you want to recommend!

# License

This plugin is licensed under the same terms as Perl itself.

#Copyright

Copyright 2012, Endevver LLC. All rights reserved.
