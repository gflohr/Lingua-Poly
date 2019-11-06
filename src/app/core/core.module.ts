import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { TranslateModule } from '@ngx-translate/core';
import { TranslateService, TranslateLoader } from '@ngx-translate/core';
import { TranslateHttpLoader } from '@ngx-translate/http-loader';
import { HttpClient } from '@angular/common/http';
import { HttpClientModule } from '@angular/common/http';
import { PasswordValidator } from './validators/passwordValidator';
import { ApiModule, BASE_PATH } from './openapi/lingua-poly';
import { environment } from 'src/environments/environment';

export function HttpLoaderFactory(httpClient: HttpClient) {
  return new TranslateHttpLoader(httpClient, './assets/i18n/', '.json');
}

@NgModule({
	imports: [
		CommonModule,
		TranslateModule.forRoot({
			loader: {
				provide: TranslateLoader,
				useFactory: HttpLoaderFactory,
				deps: [HttpClient]
			},
				useDefaultLang: true
		}),
		HttpClientModule,
		ApiModule
	],
  	exports: [
		TranslateModule
	],
	declarations: [],
	providers: [
		HttpClient,
		TranslateService,
		PasswordValidator,
		{
			provide: BASE_PATH, useValue: environment.basePath
		}
	]
})

export class CoreModule { }
