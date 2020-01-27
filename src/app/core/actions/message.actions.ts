import { createAction, props } from '@ngrx/store';

export const displayError = createAction(
	'[Core] Display Error',
	props<{ code: string }>()
);
