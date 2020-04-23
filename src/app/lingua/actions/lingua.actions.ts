import { createAction, props } from '@ngrx/store';

export const UILinguaChangeRequested = createAction(
	'[UI] Request UI Language Change',
	props<{ lingua: string }>()
);

export const UILinguaChangeDetected = createAction(
	'[Router] UI Language Change Detected',
	props<{ lingua: string }>()
);

export const UILinguaChanged = createAction(
	'[I18N] UI Language Change Success',
	props<{ lingua: string}>()
);
