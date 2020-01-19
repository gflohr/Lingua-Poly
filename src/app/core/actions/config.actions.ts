import { createAction, props } from '@ngrx/store';
import { Config } from '../openapi/lingua-poly';

export const configRequest = createAction('[App Component] Configuration Request');
export const configSuccess = createAction(
	'[Config API] Configuration Success',
	props<{ config: Config}>()
);
export const configFailure = createAction(
	'[Config API] Configuration Error',
	props<{ error: any }>()
);
