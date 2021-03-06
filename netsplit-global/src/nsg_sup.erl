-module(nsg_sup).
-behaviour(supervisor).

-export([start_link/0,
         init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init(_Args) ->
    {ok, {#{startegy => one_for_one,
            intensity => 5,
            period => 1000},
          [
           child(nsg_cluster_mgr, []),
           child_sup(nsg_channel_sup, [])
          ]}
         }.

child(Module, Args) ->
    #{id => Module,
      start => {Module, start_link, Args},
      restart => permanent,
      shutdown => brutal_kill,
      type => worker,
      modules => []}.

child_sup(Module, Args) ->
    Spec = child(Module, Args),
    Spec#{shutdown => infinity,
          type => supervisor}.
