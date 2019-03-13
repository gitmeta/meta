public extension User {
    public func validate() {
        access = access?.validate() == true ? access : nil
        home = home?.validate() == true ? home : nil
    }
}
