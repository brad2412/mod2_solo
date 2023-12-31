class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :invoice_items
  has_many :transactions

  validates :status, presence: true

  enum :status, ["cancelled", "completed", "in progress"]

  def self.incomplete_invoices
    Invoice.joins(:invoice_items).where.not(invoice_items: {status: 0}).order(created_at: :desc).distinct
  end

  def formatted_date
    created_at.strftime("%A, %B %-d, %Y")
  end

  def total_revenue
    invoice_items.sum('quantity*unit_price')
  end

  def invoice_items_for(merchant)
    invoice_items.joins(:item).where('merchant_id = ?', merchant.id)
  end

  def revenue_for(merchant)
    invoice_items.joins(:item).where('merchant_id = ?', merchant.id).sum('invoice_items.quantity*invoice_items.unit_price')
  end
end