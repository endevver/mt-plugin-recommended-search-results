package RecommendedSearchResults::Tags;

use strict;
use warnings;

use base 'MT::App::Search';

use Data::Dumper;

sub tag_block_recommended_search_results {
    my ($ctx, $args, $cond) = @_;
    my $app                 = MT->instance;
    my $stash_key           = $ctx->stash('stash_key') || 'entry';
    my ( $this_object, $next_object );

    my @arguments        = $app->search_terms();
    my ( $count, $iter ) = $app->execute(@arguments);
    # If there are no search results, just give up.
    return '' unless $count && $iter;

    # A tag is used to restrict the search results to a smaller recommended
    # list. That is, the recommended item must appear in the search results,
    # and a specified tag will be used to filter the search results to get
    # the desired recommended items out.
    # If no tag is supplied, then the recommended list would be exactly the
    # same as the regular search results, so just give up if there is no tag
    # supplied.
    my $tag_name = $args->{'tag'}
        or return '';
    my $tag = MT->model('tag')->load({ name => $tag_name, })
        or return '';

    # Create an array with only the objects that have the supplied tag
    # associated.
    my @objects;
    while ($this_object = $iter->() ) {
        # If the object *is* associated with the selected tag, then save it.
        if (
            MT->model('objecttag')->exist({
                object_id => $this_object->id,
                blog_id   => $this_object->blog_id,
                tag_id    => $tag->id,
            })
        ) {
            push @objects, $this_object;
        }
    }

    my $builder = $ctx->stash('builder');
    my $tokens  = $ctx->stash('tokens');
    my $output  = '';

    my $blog_header = 1;
    my $blog_footer = 0;
    my $max_reached = 0;

    my $i = 0;

    # Use the just-created array to build the tag so that the recommended list
    # can be published.
    foreach my $object (@objects) {
        $ctx->stash($stash_key, $object);
        local $ctx->{__stash}{blog} = $object->blog
            if $object->can('blog');
        my $ts;
        if ( $object->isa('MT::Entry') ) {
            $ts = $object->authored_on;
        }
        elsif ( $object->properties->{audit} ) {
            $ts = $object->created_on;
        }
        local $ctx->{current_timestamp} = $ts;

        # Assign the meta vars
        local $ctx->{__stash}{vars}->{__first__}   = !$i;
        local $ctx->{__stash}{vars}->{__last__}    = ($object == $objects[-1]);
        local $ctx->{__stash}{vars}->{__odd__}     = ($i % 2) == 0; # 0-based $i
        local $ctx->{__stash}{vars}->{__even__}    = ($i % 2) == 1;
        local $ctx->{__stash}{vars}->{__counter__} = $i + 1;

        defined(my $out = $builder->build($ctx, $tokens,
            { %$cond, 
                # Include the SearchResultsHeader/Footer just in case people
                # use them.
                SearchResultsHeader => $i == 0,
                SearchResultsFooter => ($object == $objects[-1]),
            }
            )) or return $ctx->error( $builder->errstr );

        $output .= $out;

        $i++;
    }

    $output;
}

1;

__END__
