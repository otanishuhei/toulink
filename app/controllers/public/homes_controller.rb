class Public::HomesController < ApplicationController
  def top
    # 新着投稿8件（投稿日時が新しい順）
    @new_posts = Post.published.order(created_at: :desc).limit(9)
    # 人気コミュニティグループ3件（メンバー数が多い順）
    @popular_communities = Community.active.left_joins(:community_members)
                                    .group(:id)
                                    .order("COUNT(community_members.id) DESC")
                                    .limit(3)
  end

  def about
  end

  def privacy_policy
  end

  def terms_of_service
  end
end
