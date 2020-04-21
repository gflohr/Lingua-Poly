import { createAction, props } from '@ngrx/store';

export const changeUILanguageRequest = createAction(
	'[UI] Request UI Language Change',
	props<{ lingua: string }>()
);

export const changeUILanguageSuccess = createAction(
	'[I18N] UI Language Change Success',
	props<{ lingua: string}>()
);
