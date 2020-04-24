import { Injectable } from '@angular/core';
import { Actions, createEffect, ofType } from '@ngrx/effects';
import { LinguaActions } from './actions';
import { map, switchMap, tap, filter } from 'rxjs/operators';
import * as fromUser from '../user/reducers';
import { Store, select } from '@ngrx/store';
import { Observable } from 'rxjs';
import { TranslateService } from '@ngx-translate/core';

@Injectable()
export class LinguaEffects {
	uiLingua$: Observable<string>;

	constructor(
		private actions$: Actions,
		private userStore: Store<fromUser.State>,
		private translate: TranslateService,
	) {
		this.uiLingua$ = this.userStore.pipe(select(fromUser.selectUILingua));
	}

	UILinguaChange$ = createEffect(() => this.actions$.pipe(
		ofType(LinguaActions.UILinguaChangeDetected),
		map(action => action.lingua),
		switchMap(uiLingua => this.uiLingua$.pipe(
			filter(oldUILingua => oldUILingua !== uiLingua),
			tap(() => this.translate.use(uiLingua)),
			map(() => LinguaActions.UILinguaChanged({ lingua: uiLingua })),
		)),
	));
}
