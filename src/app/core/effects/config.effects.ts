import { Injectable } from '@angular/core';
import { of } from 'rxjs';
import { createEffect, Actions, ofType } from '@ngrx/effects';
import { map, exhaustMap, catchError, tap } from 'rxjs/operators';
import { ConfigActions } from '../actions';
import { CoreService } from '../openapi/lingua-poly';

@Injectable()
export class ConfigEffects {
	getConfig$ = createEffect(() => this.actions$.pipe(
		ofType(ConfigActions.configRequest),
		exhaustMap(() =>
			this.coreService.configGet().pipe(
				map(config => ConfigActions.configSuccess({ config })),
				catchError(error => of(ConfigActions.configFailure({ error })))
			)
		)
	));

	constructor(
		private actions$: Actions,
		private coreService: CoreService,
	) { }
}
