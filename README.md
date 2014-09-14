# Knight

I got tired of wiring up the components of my Lua applications and managing
their dependencies, so I built a super simple dependency injector, somewhat
like Angular.js has.

Modules are namespaced dependency graphs. Components are whatever you are
wiring together. Components can be classes or services or constants; Knight
doesn't care.

