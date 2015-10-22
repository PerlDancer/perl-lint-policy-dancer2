get '/' => sub {
    ...
};

get '' => sub {
    ...
};

get qr{^/} => sub {
    ...
};

get '/hello' => sub {...};

get 'hello' => sub {...};
get "hello" => sub {...};
