import { Component } from '@angular/core';
import { Store } from '@ngrx/store';
import { increment, decrement, reset } from '../../store/counter.actions';
import { CounterState } from '../../store/counter.reducer';
import { Observable } from 'rxjs';
import { selectCount } from '../../store/counter.selectors'; // Import the selector
import { AsyncPipe, JsonPipe } from '@angular/common'; // Import AsyncPipe
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-counter',
  imports: [AsyncPipe, JsonPipe],
  templateUrl: './counter.html',
  styleUrl: './counter.scss',
})
export class Counter {
  count$: Observable<number>;
  jsonData: any;

  constructor(private store: Store<{ counter: CounterState }>, private http: HttpClient) {
    this.count$ = this.store.select(selectCount); // Using a selector
    // Or directly: this.count$ = this.store.select(state => state.counter.count);
    // this.count$ = this.store.select(state => state.counter.count);
  }

  increment() {
    this.store.dispatch(increment());
  }

  decrement() {
    this.store.dispatch(decrement());
  }

  reset() {
    this.store.dispatch(reset({ value: 0 }));
  }

  fetchData() {
    const url = 'http://localhost/api/base/weatherforecast'; // Replace with your API URL
    this.http.get(url).subscribe({
      next: (data) => {
        this.jsonData = data; // Save the response to your variable
        console.log('Data received:', this.jsonData);
      },
      error: (err) => console.error('Error fetching data:', err)
    });
  }
}
