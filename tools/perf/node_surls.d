#!/usr/sbin/dtrace -s
/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

/*
 * Copyright (c) 2014, Joyent, Inc.
 */

/*
 * Taken from git@github.com:brendangregg/dtrace-cloud-tools.git
 *
 * node_surls.d		node.js server URL summary.
 *
 * This traces all node processes on the system.
 *
 * Requires the node DTrace provider, and a working version of the node
 * translator (/usr/lib/dtrace/node.d).
 *
 * 26-Jun-2013	Brendan Gregg	Created this.
 */

#pragma D option quiet

dtrace:::BEGIN
{
	printf("Tracing node server URLs. Summary every 10 secs or Ctrl-C.\n");
}

node*:::http-server-request
{
	@[args[0]->url] = count();
}

profile:::tick-10s
{
	printf("\n%Y:\n", walltimestamp);
	printa("   %@6d %s\n", @);
	trunc(@);
}
