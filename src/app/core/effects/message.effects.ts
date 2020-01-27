import { Injectable } from '@angular/core';
import { createEffect, ofType, Actions } from '@ngrx/effects';
import { MessageActions } from '../actions';

@Injectable()
export class ConfigEffects {
	displayMessage$ = createEffect(() => this.actions$.pipe(
		ofType(MessageActions.displayError),
	), { dispatch: false });

	constructor(
		private actions$: Actions,
	) { }
}
