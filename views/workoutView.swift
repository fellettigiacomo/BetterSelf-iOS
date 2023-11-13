//
//  workoutView.swift
//  gymui
//
//  Created by jack on 08/11/23.
//

import SwiftUI

struct workoutView: View {
  var currentSection: Section
  @Environment(\.colorScheme) var colorScheme

  @State private var remainingSets = 3
  //@State private var currentExercise = "Bench Press"
  @State private var isPaused = false
  @State private var currentSet = 1
  @State private var weight = 20
  @State private var reps = 10

  @State private var exerciseIndex = 0
  @State private var rest = false
  @State private var totalSets = 0
  @State private var restTimeElapsed = 0
  @State private var totalTimeElapsed = 0
  @State private var doneSets = 0
  @State private var totalRestElapsed = 0

  let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

  var body: some View {
    let exercises = currentSection.exercises
    let currentExercise = exercises[exerciseIndex]
    let totalSets = exercises.reduce(0) { $0 + $1.sets }
    let remainingSets = currentExercise.sets - currentSet

      VStack {
      Text("\(currentSection.name)  -  \(currentSection.muscleGroup)")
        .font(.title)
        .padding()

      HStack {
        // INDIETRO
        Button(action: {
          if exerciseIndex >= 1 {
            exerciseIndex -= 1
          }
        }) {
          if exerciseIndex >= 1 {
            Image(systemName: "arrowtriangle.backward.fill")
              .font(.title)
          } else {
            Image(systemName: "arrowtriangle.backward")
              .font(.title)
          }
        }
        .padding()
        Spacer()

        // ESERCIZIO
        Text(currentExercise.name)
          .font(.headline)
        Spacer()

        // AVANTI
        Button(action: {
          //MARK: METTERE CONTROLLO PER OUT-OF-RANGE
          exerciseIndex += 1
          doneSets += remainingSets
          // Go to next exercise
        }) {
          Image(systemName: "arrowtriangle.forward.fill")
            .font(.title)
        }
        .padding()
      }
      .padding()

      // MAIN VIEW
      VStack {

        Text("Serie \(currentSet) di \(currentExercise.sets)")
          .font(.headline)
        Text("\(currentExercise.reps) * \(Int(currentExercise.weight)) kg")
          .font(.largeTitle)
      }

      // BARRA PROGRESSO
      VStack {
        if !rest {
          Text(String(format: "%02d:%02d", Int(totalTimeElapsed / 60), Int(totalTimeElapsed) % 60))
            .font(.largeTitle)
          ProgressView(value: (Double(doneSets) / Double(totalSets)))
            .progressViewStyle(LinearProgressViewStyle(tint: .green))
          Text("Tempo totale")
            .font(.headline.bold())
        } else {
          Text(String(format: "%02d:%02d", Int(restTimeElapsed / 60), Int(restTimeElapsed) % 60))
            .font(.largeTitle)
          ProgressView(value: (Double(restTimeElapsed) / Double(currentExercise.rest)))
            .progressViewStyle(LinearProgressViewStyle(tint: .yellow))
          Text("Recupero")
            .font(.headline.bold())
        }
      }.frame(alignment: .bottom).padding()
      // BOTTONI SOTTO
          HStack(content: {
        if !rest {
          Button(action: {
            rest = !rest
            doneSets += 1
            currentSet += 1
            if currentSet > currentExercise.sets {
              exerciseIndex += 1
              currentSet = 1
            }
          }) {
            Text("Serie completata")
          }
          .frame(width: 150, height: 40)
          .background(colorScheme == .dark ? Color.white : Color.black)
          .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
          .cornerRadius(15)
          .padding()
        } else {
          Button(action: {
            rest = !rest
            totalRestElapsed += restTimeElapsed
            restTimeElapsed = 0
          }) {
            Text("Salta recupero")
          }
          .frame(width: 150, height: 40)
          .background(colorScheme == .dark ? Color.white : Color.black)
          .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
          .cornerRadius(15)
          .padding()
        }

        Spacer()

        Button(action: {
          isPaused.toggle()
        }) {
          Image(systemName: isPaused ? "play.fill" : "pause.fill")
            .font(.title)
        }
        .frame(width: 150, height: 40)
        .background(colorScheme == .dark ? Color.white : Color.black)
        .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
        .cornerRadius(15)
        .padding()
      }).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }.navigationBarTitle(Text(currentExercise.name), displayMode: .inline)
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
      // LOGICA TIMER
      .onReceive(timer) { _ in
        if !isPaused {
          totalTimeElapsed += 1
          // logica per il riposo
          if rest {
            restTimeElapsed += 1
            if restTimeElapsed == currentExercise.rest {
              exerciseIndex += 1
              rest = !rest
            }
          }
        }
      }
  }
}

struct WorkoutView_Previews: PreviewProvider {
  static var previews: some View {
    let flMgr = WorkoutParser()
    workoutView(currentSection: flMgr.parseXML()[0])
  }
}
