module PrivateClassMethod
  def private_class_method(*args)
    # 引数が指定されない時は、
    if args.empty?
      # 特異メソッドが追加された時に、
      def self.singleton_method_added(name)
        # 特異メソッドを private に指定
        private_class_method name
      end
      # クラスが継承された場合、
      def self.inherited(subclass)
        # 特異メソッドを private にする機能を無効化
        subclass.class_eval do
          def self.singleton_method_added(name)
          end
        end
      end
    else
      # 引数が空でない時は元の動き
      super
    end
  end
end