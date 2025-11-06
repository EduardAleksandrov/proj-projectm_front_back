import { Component } from '@angular/core';

@Component({
  selector: 'app-about',
  imports: [],
  templateUrl: './about.html',
  styleUrl: './about.scss',
})
export class About {
  title: string = 'About Us';
  description: string = 'This is a simple page component in Angular.';

}
