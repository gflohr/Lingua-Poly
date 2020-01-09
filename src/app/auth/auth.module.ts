import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { authRoutes } from './auth.routes';
import { LoginComponent } from './components/login/login.component';
import { RegistrationComponent } from './components/registration/registration.component';
import { ReactiveFormsModule, FormsModule } from '@angular/forms';
import { RegistrationReceivedComponent } from './components/registration-received/registration-received.component';
import { CoreModule } from '../core/core.module';
import { RegistrationConfirmedComponent } from './components/registration-confirmed/registration-confirmed.component';
import { StoreModule } from '@ngrx/store';
import { EffectsModule } from '@ngrx/effects';
import { AuthEffects } from './auth.effects';

import * as fromAuth from './reducers';

@NgModule({
	imports: [
		CommonModule,
		RouterModule.forChild(authRoutes),
		CoreModule,
		FormsModule,
		ReactiveFormsModule,
		StoreModule.forFeature(fromAuth.authFeatureKey, fromAuth.authReducers),
		EffectsModule.forFeature([AuthEffects])
	],
	declarations: [
		LoginComponent,
		RegistrationComponent,
		RegistrationReceivedComponent,
		RegistrationConfirmedComponent
	]
})
export class AuthModule { }
