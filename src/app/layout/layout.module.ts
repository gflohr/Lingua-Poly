import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';

import { HeaderComponent } from './header/header.component';

@NgModule({
  imports: [
    CommonModule,
    NgbModule
  ],
  exports: [
    HeaderComponent
  ],
  declarations: [
    HeaderComponent
  ]
})
export class LayoutModule { }
