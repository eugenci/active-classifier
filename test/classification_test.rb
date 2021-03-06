require 'test_helper'

class ManitouClassificationTest < ActiveSupport::TestCase

  test "classified" do
    assert ! Item.classified?, "shouldn't be classified"
    assert Device.classified?, "should be classified"
    assert Modem.classified?, "should be classified"
  end

  test "attributes_class" do
    assert_equal nil, Item.attributes_class, "should be nil"
    assert_equal DeviceAttribute, Device.attributes_class, "should be DeviceAttribute"
    assert_equal ModemAttribute, Modem.attributes_class, "should be ModemAttribute"
  end

  test "inheritance_array" do
    assert_equal [Item, Device, Modem], Modem.inheritance_array, "should return array in valid order"
  end

  test "inheritance_queue" do
    a = []

    Modem.inheritance_queue { |cls, c| a << [cls, c]}

    assert_equal [[Modem,true],[Device,true],[Item,false]], a, "should process queue in reverse order"
  end

  test "attr_for relations with disabled classification" do
    assert Item.reflect_on_association(:attr_for_item).nil?, "should be nil"
  end

  test "attr_for relations with not classified parent" do
    association = Device.reflect_on_association(:attr_for_device)
    assert_equal :attr_for_device, association.name, "should provide valid association name"
    assert_equal :has_one, association.macro, "should provide valid association macro"
  end

  test "attr_for relations with classified parent" do
    association1 = Modem.reflect_on_association(:attr_for_modem)
    assert_equal :attr_for_modem, association1.name, "should provide valid self attributes association name"
    assert_equal :has_one, association1.macro, "should provide valid self attributes association macro"

    association2 = Modem.reflect_on_association(:attr_for_device)
    assert_equal :attr_for_device, association2.name, "should provide valid parent association name"
    assert_equal :has_one, association2.macro, "should provide valid parent association macro"
  end

  test "attr_for relations with non classified ancestor in the middle" do

    assert_equal 3, Telsey.reflect_on_all_associations.size, "should add only 3 associations"

    association1 = Telsey.reflect_on_association(:attr_for_modem)
    assert_equal :attr_for_modem, association1.name, "should provide valid self attributes association name"
    assert_equal :has_one, association1.macro, "should provide valid self attributes association macro"

    association2 = Telsey.reflect_on_association(:attr_for_device)
    assert_equal :attr_for_device, association2.name, "should provide valid parent association name"
    assert_equal :has_one, association2.macro, "should provide valid parent association macro"

    association3 = Telsey.reflect_on_association(:attr_for_telsey)
    assert_equal :attr_for_telsey, association3.name, "should provide valid parent association name"
    assert_equal :has_one, association3.macro, "should provide valid parent association macro"
  end

  test "class_for_field" do
    assert_equal Telsey, Telsey.class_for_field(:name), "should return Telsey for name"
    assert_equal TelseyAttribute, Telsey.class_for_field(:mac), "should return Telsey for name"
    assert_equal ModemAttribute, Telsey.class_for_field(:num_of_ifs), "should return Telsey for name"
  end

  test "fields_for_class" do
    assert_equal(
      [
        ["id", "name", "type", "created_at", "updated_at"],
        ["attr_for_telsey", ["mac"]],
        ["attr_for_modem", ["num_of_ifs", "line"]],
        ["attr_for_device", ["vendor", "issued_at"]]
      ],
      Telsey.fields_for_class,
      "should return fields structure"
    )
  end

  test "field_names_for_class" do
    assert_equal ["id", "name", "type", "created_at", "updated_at", "attr_for_telsey", "mac",
      "attr_for_modem", "num_of_ifs", "line", "attr_for_device", "vendor", "issued_at"],
      Telsey.field_names_for_class, "should return field names"
  end

  test "create with direct inherited attributes" do
    Telsey.create! :name => 'modem1'
    modem = Telsey.first
    assert_equal 'modem1', modem.name, "should set direct inherited attribute name"
    assert modem.attr_for_device.nil?, "attr_for_device should be nil"
    assert modem.attr_for_modem.nil?, "attr_for_device should be nil"
    assert modem.attr_for_telsey.nil?, "attr_for_device should be nil"
  end

  test "create with additional attributes" do
    Telsey.create! :name => 'modem1', :mac => '00:00:00:00:00:00', :vendor => 'Telsey S.r.I'
    modem = Telsey.first
    assert_equal 'modem1', modem.name, "should set direct inherited attribute name"
    assert_equal 'Telsey S.r.I', modem.vendor, "should return additional attribute from attr_for_device"
    assert modem.attr_for_modem.nil?, "attr_for_device should be nil"
    assert_equal '00:00:00:00:00:00', modem.mac, "should return additional attribute from attr_for_telsey"
  end

end
