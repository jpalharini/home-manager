(ns user
  (:require [clojure.tools.namespace.repl :as repl]
            [clj-java-decompiler.core :refer [decompile]]
            [clj-memory-meter.core :as mm])
  (:import [java.lang.management ManagementFactory]))

(set! *warn-on-reflection* true)

(defn refresh-all-but [ns]
  (when-let [ns (find-ns ns)]
    (doto ns
      (repl/disable-reload!)
      (repl/disable-unload!)))
  (repl/refresh))

(defmacro print-and-return [expr]
  `(do (println ~expr)
       ~expr))

(defmacro cpu-time
  "Evaluates expr and measures the CPU time it took. Returns the value of expr.
   If print? is set to false, returns a tuple of value of expr and CPU time in millis."
  [expr & {:keys [print?]
           :or   {print? true}}]
  `(let [cpu-time-fn# (fn [] (-> (ManagementFactory/getThreadMXBean)
                                 (.getCurrentThreadCpuTime)))
         start#       (cpu-time-fn#)
         ret#         ~expr
         elapsed-ms#  (-> (cpu-time-fn#)
                          (- start#)
                          (double)
                          (/ 1000000.0))]
     (if ~print?
       (do (prn (str "Elapsed time: " elapsed-ms# " msecs"))
           ret#)
       [ret# elapsed-ms#])))