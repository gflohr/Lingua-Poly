import { Injectable } from '@angular/core';
import { createEffect, ofType, Actions } from '@ngrx/effects';
import { MessageActions } from '../actions';
import { ErrorCodesService } from '../services/error-codes.service';
import { filter, tap, exhaustMap, catchError } from 'rxjs/operators';
import { ModalDialogService } from '../services/modal-dialog.service';
import { ErrorMessageComponent } from '../../layout/components/error-message/error-message.component';
import { EMPTY } from 'rxjs';

@Injectable()
export class MessageEffects {
	displayMessage$ = createEffect(() => this.actions$.pipe(
		ofType(MessageActions.displayError),
		tap(() => console.log('display message?')),
		filter((action) => this.errorCodesService.message(action.code) != null),
		tap((action) => this.errorCodesService.changeCode(action.code)),
		exhaustMap(() => this.dialogService.runDialog(ErrorMessageComponent).pipe(
			catchError(() => EMPTY))
		)
	), { dispatch: false });

	constructor(
		private actions$: Actions,
		private errorCodesService: ErrorCodesService,
		private dialogService: ModalDialogService,
	) { }
}
