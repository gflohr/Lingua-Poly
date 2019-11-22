import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { TranslateModule } from '@ngx-translate/core';
import { TranslateService, TranslateLoader } from '@ngx-translate/core';
import { TranslateHttpLoader } from '@ngx-translate/http-loader';
import { HttpClient, HTTP_INTERCEPTORS } from '@angular/common/http';
import { HttpClientModule } from '@angular/common/http';
import { PasswordValidator } from './validators/passwordValidator';
import { ApiModule, BASE_PATH } from './openapi/lingua-poly';
import { environment } from 'src/environments/environment';
import { ApiInterceptorService } from './services/api-interceptor.service';

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
		},
		{
			provide: HTTP_INTERCEPTORS,
			useClass: ApiInterceptorService,
			multi: true
		}
	]
})

export class CoreModule { }
