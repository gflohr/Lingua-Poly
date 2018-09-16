import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { mainRoutes }  from './main.routes';
import { StartComponent } from './components/start/start.component';
import { LegalDisclosureComponent } from './components/legal-disclosure/legal-disclosure.component';

@NgModule({
  imports: [
    CommonModule,
    RouterModule.forChild(mainRoutes)
  ],
  declarations: [StartComponent, LegalDisclosureComponent]
})
export class MainModule { }
