use Dancer2;

get "/all" => sub {
    my $params = params;
};

get '/all_foo' => sub {
    my $params = params->{'foo'};
};

get '/all_parens' => sub {
    my $params = params();
};

get '/all_parens_foo' => sub {
    my $params = params()->{'foo'};
};

__PACKAGE__->to_app;
