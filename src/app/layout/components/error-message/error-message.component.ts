import { Component, OnInit } from '@angular/core';
import { NgbActiveModal } from '@ng-bootstrap/ng-bootstrap';

@Component({
  selector: 'app-error-message',
  templateUrl: './error-message.component.html',
  styleUrls: ['./error-message.component.sass']
})
export class ErrorMessageComponent implements OnInit {

	title = 'Hello, world!';
	message = 'It\'s a sad and beautiful world!';

	constructor(
		public activeModal: NgbActiveModal
	) {}

	ngOnInit() {
	}

}
