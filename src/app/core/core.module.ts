import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { TranslateModule } from '@ngx-translate/core';
import { TranslateService, TranslateLoader } from '@ngx-translate/core';
import { TranslateHttpLoader } from '@ngx-translate/http-loader';
import { HttpClient, HttpClientModule, HTTP_INTERCEPTORS } from '@angular/common/http';
import { PasswordValidator } from './validators/passwordValidator';
import { ApiModule, BASE_PATH } from './openapi/lingua-poly';
import { environment } from 'src/environments/environment';
import { EffectsModule } from '@ngrx/effects';
import { AuthEffects } from '../auth/auth.effects';
import { ConnectFormDirective } from './directives/connect-form.directive';
import { StoreModule } from '@ngrx/store';
import * as fromCore from './reducers';
import { CookieService } from 'ngx-cookie-service';

export function HttpLoaderFactory(httpClient: HttpClient) {
	return new TranslateHttpLoader(httpClient, './assets/i18n/', '.json');
}

@NgModule({
	imports: [
		CommonModule,
		EffectsModule.forRoot([
			AuthEffects
		]),
		TranslateModule.forRoot({
			loader: {
				provide: TranslateLoader,
				useFactory: HttpLoaderFactory,
				deps: [HttpClient]
			},
			useDefaultLang: true
		}),
		HttpClientModule,
		ApiModule,
		StoreModule.forFeature(fromCore.coreFeatureKey, fromCore.coreReducers),
	],
		exports: [
		TranslateModule,
		ConnectFormDirective
	],
	declarations: [ConnectFormDirective],
	providers: [
		HttpClient,
		TranslateService,
		PasswordValidator,
		CookieService,
		{
			provide: BASE_PATH, useValue: environment.basePath
		},
	]
})

export class CoreModule { }
