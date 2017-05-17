require 'spec_helper'

describe Planter::GithubIssueParser do
  describe "#parse_issue_numbers_from_pull_request" do
    context "with issue references in the PR body" do
      let(:pr_body) do
        <<-END.gsub(/^\s+\|/, "")
          |**Related Issue(s)**
          |close #1
          |closes #2
          |closed #3
          |fix #4
          |fixes #5
          |fixed #6
          |resolve #7
          |resolves #8
          |resolved #9
          |Close #10
          |Closes #11
          |Closed #12
          |Fix #13
          |Fixes #14
          |Fixed #15
          |Resolve #16
          |Resolves #17
          |Resolved #18
          |
          |**Acceptance Test(s)**
          |#8 https://gist.github.com/blim8183/30aea7e5fdeadcfc33c3b4a44b31bcd9
          |#9 https://gist.github.com/blim8183/485a5d292fee4c14c666888161101573
          |#10 https://gist.github.com/blim8183/89af7657a003e8a412024bf9c2855179
          |
          |**Implementation Notes**
          |This PR contains the functional implementation for the /repos page
          |
          |**Related Pull Request(s)**
          |Yes
          |Reliant on https://github.com/ableco/fino/pull/86 being merged
          |
          |**Outstanding Tasks**
          |- [x] Ability to update membership activity details in one batch
          |
          |**Requires Migration(s)**
          |No
        END
      end

      it "correctly parses the issue numbers out of a pull request" do
        expect(subject.parse_issue_numbers_from_pull_request_body(pr_body)).to eq(
          [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18]
        )
      end
    end

    context "without issue references in the PR body" do
      let(:pr_body) { "Mike is a robot." }

      it "returns an empty array" do
        expect(subject.parse_issue_numbers_from_pull_request_body(pr_body)).to eq([])
      end
    end
  end
end
