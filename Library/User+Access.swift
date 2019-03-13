public extension User {
    public func validate() { access = access?.validate() == true ? access : nil }
}
