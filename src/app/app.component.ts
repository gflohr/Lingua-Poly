import { Component } from '@angular/core';
import { TranslateService } from '@ngx-translate/core';
import { applicationConfig } from './app.config';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'app';
  constructor(
    private translate: TranslateService
  ) { 
    translate.setDefaultLang(applicationConfig.defaultLocale);
    translate.use(applicationConfig.defaultLocale);
  };
}
