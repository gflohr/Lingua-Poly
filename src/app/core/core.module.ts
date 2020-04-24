import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { TranslateModule } from '@ngx-translate/core';
import { HttpClient, HttpClientModule, HTTP_INTERCEPTORS } from '@angular/common/http';
import { PasswordValidator } from './validators/passwordValidator';
import { BASE_PATH } from './openapi/lingua-poly';
import { environment } from 'src/environments/environment';
import { EffectsModule } from '@ngrx/effects';
import { AuthEffects } from '../auth/auth.effects';
import { ConnectFormDirective } from './directives/connect-form.directive';
import { StoreModule } from '@ngrx/store';
import * as fromCore from './reducers';
import { CookieService } from 'ngx-cookie-service';

@NgModule({
	imports: [
		CommonModule,
		EffectsModule.forFeature([
			AuthEffects
		]),
		HttpClientModule,
		StoreModule.forFeature(fromCore.coreFeatureKey, fromCore.coreReducers),
	],
		exports: [
		TranslateModule,
		ConnectFormDirective
	],
	declarations: [ConnectFormDirective],
	providers: [
		HttpClient,
		PasswordValidator,
		CookieService,
		{
			provide: BASE_PATH, useValue: environment.basePath
		},
	]
})

export class CoreModule { }
