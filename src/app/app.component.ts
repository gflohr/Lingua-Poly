import { Component, OnInit, OnDestroy } from '@angular/core';
import { TranslateService } from '@ngx-translate/core';
import { Router, ActivatedRoute, Event, NavigationEnd } from '@angular/router';
import { applicationConfig } from './app.config';

import { filter } from 'rxjs/operators';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})

export class AppComponent implements OnInit, OnDestroy {
  title = 'app';
  private sub: any;

  constructor(private translate: TranslateService, private router: Router,
              private route: ActivatedRoute) {
    translate.setDefaultLang(applicationConfig.defaultLocale);
    translate.use(applicationConfig.defaultLocale);

    this.router.events.pipe(
      filter((event:Event) => event instanceof NavigationEnd)
    ).subscribe(x => console.log(x));
  };

  ngOnInit() {
    this.sub = this.route.params.subscribe(params => {
       console.log(params);
    });
  }

  ngOnDestroy() {
    this.sub.unsubscribe();
  }
}
