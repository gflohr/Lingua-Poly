import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { applicationConfig } from '../app.config';
import { TranslateModule } from '@ngx-translate/core';
import { TranslateService, TranslateLoader } from '@ngx-translate/core';
import { TranslateHttpLoader } from '@ngx-translate/http-loader';
import { HttpClient } from '@angular/common/http';
import { HttpClientModule } from '@angular/common/http';

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
  ],
  exports: [
    TranslateModule
  ],
  declarations: [],
  providers: [
    HttpClient,
    TranslateService 
  ]
})
export class CoreModule { }
