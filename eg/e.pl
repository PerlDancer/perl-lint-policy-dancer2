get '/ok' => sub {
    params('query')->{'foo'};
};

get '/fail1' => sub {
    params()->{'foo'};
};

get '/fail2' => sub {
    params->{'foo'};
};
