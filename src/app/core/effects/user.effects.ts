import { Injectable } from '@angular/core';
import { fromEvent, merge, timer } from 'rxjs';
import { createEffect } from '@ngrx/effects';
import { map, switchMapTo } from 'rxjs/operators';
import { UserActions } from '../actions';

@Injectable()
export class UserEffects {
	clicks$ = fromEvent(document, 'click');
	keys$ = fromEvent(document, 'keydown');
	mouse$ = fromEvent(document, 'mousemove');

	// FIXME! This is the wrong approach. Activity for us exclusively means
	// API calls.  And the maximum allowed idle time comes from the server.
	idle$ = createEffect(() =>
		merge(this.clicks$, this.keys$, this.mouse$).pipe(
			switchMapTo(timer(5 * 60 * 1000)), // 5 minute inactivity timeout
			map(() => UserActions.idleTimeout())
		)
	);
}
