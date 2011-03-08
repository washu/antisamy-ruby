require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module AntiSamy
  describe AntiSamy do
    let(:policy_file) {"#{File.join(File.dirname(__FILE__), '..', 'policy-examples')}/antisamy.xml"}

    it "should load a policy" do
      p = AntiSamy.policy(policy_file)
      p.should_not == nil
    end

    it "should scan our sample html and change nothing" do
      input = "<p>Hi</p>"
      p = AntiSamy.policy(policy_file)
      r = AntiSamy.scan(input,p)
      r.clean_html.should == input
    end

    it "should tak our input and remove the script tags" do
      input = "<p>Hi</p><script> some junk</script>"
      expec = "<p>Hi</p>"
      p = AntiSamy.policy(policy_file)
      r = AntiSamy.scan(input,p)
      r.clean_html.should == expec
    end

  end
end
